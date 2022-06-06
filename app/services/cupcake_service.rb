class CupcakeService
  def upload file, params = {}
    namespace = params[:namespace]
    is_public = params.fetch(:public, false).to_s

    raise StandardError.new('namespace is required') if namespace.blank?

    response = RestClient.post "#{ENV['CUPCAKE_HOST']}/api/v1/direct_uploads", {
      blob: {
        filename: params[:filename],
        content_type: params[:content_type],
        byte_size: file.size,
        checksum: Digest::MD5.file(file.path).base64digest
      }
    }, {
      params: {
        namespace: namespace,
        public: is_public
      }
    }

    data = JSON.parse(response.body)

    file.rewind

    RestClient.put data['direct_upload']['url'], file.read, data['direct_upload']['headers']

    data
  end

  def upload_with_path path, params = {}
    namespace = params[:namespace]
    is_public = params.fetch(:public, false).to_s
    file = File.open(path)

    raise StandardError.new('namespace is required') if namespace.blank?

    response = RestClient.post "#{ENV['CUPCAKE_HOST']}/api/v1/direct_uploads", {
      blob: {
        filename: params[:filename],
        content_type: params[:content_type],
        byte_size: file.size,
        checksum: Digest::MD5.file(path).base64digest
      }
    }, {
      params: {
        namespace: namespace,
        public: is_public
      }
    }

    data = JSON.parse(response.body)
        
    mess = RestClient.put data['direct_upload']['url'], file, data['direct_upload']['headers']

    data
  end
end
  