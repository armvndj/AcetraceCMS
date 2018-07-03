
namespace :recurring do
  task init: :environment do
    Recharge.schedule!
  end
end