class Api::V1::ActionLogsController < Api::V1::ApiController
  def get_trading_history
    logs = ActionLog.order(created_at: :desc).joins("INNER JOIN users ON users.id = action_logs.actor_id").
      joins("LEFT JOIN products ON products.id = action_logs.actionable_id").
      where(state: 'finished', action_code: ['buy', 'load_money']).limit(10).
      select("action_logs.*, users.phone, products.title, products.price").as_json

    data = logs.map do |log|
      item = {}
      phone = log['phone']
      phone[0..5] = "*****"

      price = if log['action_code'] == 'buy'
        log['price']*log['action_data']['amount'].to_i
      else 
        log['action_data']['amount'].to_i
      end
      message = if log['action_code'] == 'buy'
        "Đã mua #{log['title']} thành công!"
      else
        "Đã nạp tiền tự động Vietcombank"
      end
      time = log['created_at']

      item['phone'] = phone
      item['price'] = price
      item['message'] = message
      item['time'] = time

      item
    end

    result = {
      data: data
    }

    return render json: result
  end
end
