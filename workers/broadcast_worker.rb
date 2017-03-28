class BroadcastWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: false

  def perform station_id, message, type
    Time.zone ||= TIME_ZONE
    stations = [ station_id ]
    if station_id.to_s.upcase == 'ALL'
      stations = Station.pluck(:id).uniq
    end

    stations.each do |id|
      opt = {}
      if type.upcase == 'EVACUATE'
        station = Station.find(id)
        opt = { station_id: id, station_name: station.station_name }
      end
      User.find_in_batches(batch_size: 100) do |users|
          Notification.send_notication users, { message: message, type: type }.update(opt)
      end
    end

  end
end
