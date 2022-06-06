class TransactionService
  def self.get_transactions
    url = "https://api.web2m.com/historyapivcb/#{ENV['VCB_ACCOUNT_PASSWORD']}/#{ENV['VCB_ACCOUNT_ID']}/#{ENV['VCB_ACCOUNT_TOKEN']}"
    response = RestClient.get url
    response = JSON.parse(response)

    response
  end
end