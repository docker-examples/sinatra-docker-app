class ReportsWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'
  
  def perform klass, params
    Time.zone ||= TIME_ZONE

    if klass.empty? || params.empty?
      puts "Nothing to perform. Please review the job"
    else
      symbolize_keys_deep!(params)
      email = params[:email]
      results = Object.const_get(klass).send :new, params
      mailer = Mailer.new
      # This is a Hash that will be passed to the awesome_email method
      details = {
        to: email,
        from: 'noreply@SinatraApi.com',
        subject: 'Report',
        body: 'Please find attached report',
        attachments: { results.filename => File.read(results.filename) }
      }
      mailer.awesome_email(details)
    end
  end
end
