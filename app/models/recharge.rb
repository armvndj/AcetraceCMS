class Recharge
  include Delayed::RecurringJob
  run_every 1.day
  run_at '11:00am'
  timezone 'US/Pacific'
  queue 'slow-jobs'
  def perform
    lawfirms = Lawfirm.all

    	lawfirms.each do |f|
  			if f.transactions.any?
    			last_trans = f.transactions.last
    			if Date.today > last_trans.expires_on
     			 	f.update(status: 0)
    			end
  			end
  		end

  end
end