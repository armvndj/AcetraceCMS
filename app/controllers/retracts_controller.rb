class RetractsController < ApplicationController
  #before_action :set_transaction, only: [:show, :edit, :update, :destroy]
  skip_before_action :authenticate_user!
  # GET /transactions
  # GET /transactions.json
 
  # GET /transactions/1
  # GET /transactions/1.json
  def show
    res = 0
    @paystackObj = Paystack.new(ENV['PUBLIC_KEY'], ENV['SECRET_KEY'])
    transaction_reference = params[:trxref]
    transactions = PaystackTransactions.new(@paystackObj)
    result = transactions.verify(transaction_reference)
    @res = result['data']
    @customer = result['data']['customer']
  
  if @res['status'] == "success"
    lawfirm = lawfirm.find_by_email(@customer['email']) 
      lawfirm.update(status: 1 )

      
      if lawfirm.interval == "monthly"
         res = 30
       elsif lawfirm.interval == "quarterly"
         res = 90
       elsif lawfirm == "yearly"
          res = 365
      end
       

       lawfirm.transactions.create(amount: (@res['amount'].to_f)/100,
          channel: @res['channel'], reference: @res['reference'], gateway_response: @res['gateway_response'], status: "success", gateway_response: @res['gateway_response'],
          currency: @res['currency'], status: @res['status'], expires_on: Date.today + res.days,
          created_at: Time.now, updated_at: Time.now
          )
        
  
  end

  end
  def web
    res = 0;
    @paystackObj = Paystack.new(ENV['PUBLIC_KEY'], ENV['SECRET_KEY'])
    transaction_reference = params[:trxref]
    transactions = PaystackTransactions.new(@paystackObj)
    result = transactions.verify(transaction_reference)
    @res = result['data']
  @customer = result['data']['customer']
  
  if @res['status'] == "success"
    lawfirm = lawfirm.find_by_email(@customer['email']) 
      lawfirm.update(status: 1 )

      
      if lawfirm.interval == "monthly"
         res = 30
       elsif lawfirm.interval == "quarterly"
         res = 90
       elsif lawfirm == "yearly"
          res = 365
      end
        lawfirm.transactions.create(amount: (@res['amount'].to_f)/100,
          channel: @res['channel'], reference: @res['reference'], status: "success", gateway_response: @res['gateway_response'],
          currency: @res['currency'], status: @res['status'],gateway_response: @res['gateway_response'], expires_on: Date.today + res.days,
          created_at: Time.now, updated_at: Time.now
          )
  
  end

  end
  
end
