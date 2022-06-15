class Api::V1::VariantsController < Api::V1::ApiController
  before_action :variant_product_count, only: [:index], if: -> {
    params[:action] == 'index' && params[:count_products]
  }

  before_action :variant_export, only: [:index], if: -> {
    params[:action] == 'index' && params[:export]
  }

  def variant_export
    variants = prepare_records.reorder(nil).as_json
    product_ids = variants.map{|v| v['product_id']}.uniq
    products = Product.where(id: product_ids).as_json.map{|k| [k['id'], k]}.to_h
    columns = ['account_uid', 'info', 'product', 'buyed_at']
    keys = ['account_uid', 'info', 'product', 'buyed_at']
    csv = CSV.generate(force_quotes: true) do |csv|
      csv << columns

      variants.each do |variant|
        extra = {}
        csv << keys.map { |k|
          extra['product'] = products[variant['product_id']]['title']
          extra[k] || variant[k]
        }
      end
    end

    send_data csv, type: 'text/csv', disposition: 'attachment'
  end

  def variant_product_count
    product_ids = params["count_products"]
    calculate = Variant.where(product_id: product_ids, status: 'active').
      select(:id, :product_id).as_json.group_by {|i| i["product_id"]}.map {|k, v| [k, v.count]}.to_h
    
    return render json: calculate, status: 200  
  end

  def import_variants
    if !context[:user].admin
      return render json: {
        message: "Permission denied"
      }, status: 400
    end

    file = params[:file]
    product_id = params[:kind]

    return render json: {
      message: "File and kind required!"
    }, status: 400 if (file.blank? || product_id.blank?)

    # input_file = CupcakeService.new.upload file.tempfile, {
    #   filename: file.original_filename,
    #   content_type: file.content_type,
    #   public: false,
    #   namespace: "datn/import_logs/#{context[:user].id}"
    # }

    # Create log
    log = ImportLog.create!(
      resource: 'variants',
      importer_id: context[:user].id,
      status: 'created',
      request: {
        # file: input_file['file_url']
      }
    )
        
    result = VariantGateway.new.import_variants file, context, {
      import_log: log,
      product_id: product_id
    }

    response = {
      imported: result[:data].keys.count
    }

    render json: response, status: 200
  end

  private

  def prepare_records
    resource_klass = Api::V1::VariantResource
    filters = resource_klass.verify_filters(params[:filter] || {}, context)
    filters.symbolize_keys!
    options = { context: context }

    # Let's check includes
    includes = params[:include] ? params[:include].split(',').map(&:strip) : []
    unless includes.blank?
      options[:include_directives] = JSONAPI::IncludeDirectives.new(resource_klass, includes)
    end

    # The following code was copied from gem source: JSONAPI::ActiveRelationResource.find_fragments
    # And it's crazy
    include_directives = options[:include_directives] ? options[:include_directives].include_directives : {}
    linkage_relationships = resource_klass.send(:to_one_relationships_for_linkage, include_directives[:include_related])

    options.fetch(:sort_criteria) { [] }

    join_manager = JSONAPI::ActiveRelation::JoinManager.new(resource_klass: resource_klass,
                                                            source_relationship: nil,
                                                            relationships: linkage_relationships,
                                                            # sort_criteria: sort_criteria,
                                                            filters: filters)

    resource_klass.send(:apply_request_settings_to_records, records: resource_klass.records(options),
                                  # sort_criteria: sort_criteria,
                                  filters: filters,
                                  join_manager: join_manager,
                                  # paginator: paginator,
                                  options: options
    )
  end
end
