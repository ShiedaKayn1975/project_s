module Actionable
  def self.included model
    # to use Model::Actions[action_name]
    # to use Model::Actions.all
    model.const_set :Actions, (Module.new do
      def self.all
        @actions
      end

      def self.[] code
        (@actions || {})[code]
      end

    end) unless model.const_defined?(:Actions)

    class << model
      def action name, options = {}, &block
        action_def = DefineAction.new name, options

        existing_action = (self::Actions || {})[name]

        if existing_action
          action_def.action = existing_action
          action_def.with_options = options
        end

        action_def.instance_eval &block if block_given?

        self::Actions.class_eval do
          @actions ||= {}
          @actions[name] = action_def.action
        end
      end
    end
  end

  class DefineAction
    attr_accessor :action

    def initialize name, options = {}
      @action = Action.new
      @action.code = name
    end

    def with_options options
      options.each do |key, value|
        send("#{key}", value)
      end
    end

    def label label
      @action.label = label
    end

    def show? &block
      @action.hdl_show = block
    end

    def commitable? &block
      @action.hdl_commitable = block
    end

    def authorized? &block
      @action.hdl_authorized = block
    end

    def commit &block
      @action.hdl_commit = block
    end
  end

  class Error < StandardError
  end

  class InvalidDataError < Error
  end
  
  class Context < Hash
    [:actor, :data].each do |attr_name|
      define_method attr_name do
        self[attr_name]
      end

      define_method "#{attr_name}=".to_sym do |value|
        self[attr_name] = value
      end
    end

    def initialize options = {}
      options.each do |key, value|
        self[key] = value
      end
    end
  end

  module JSONAPIResource
    def self.included base
      base.before_save do
        if @model.class.const_defined? :Actions
          @is_new = is_new?
        end
      end

      base.after_save do
        if @model.class.const_defined? :Actions
          if action = @model.class::Actions[@is_new ? :create : :update]
            ctx = Actionable::Context.new(
              actor: context[:user],
              data: {}
            )
            action_log = action.commit!(@model, ctx)
          end
        end
      end
    end
  end
end