require 'logstash/namespace'
require 'logstash/inputs/base'
require 'krakow'

class LogStash::Inputs::Nsqkrakow < LogStash::Inputs::Base
  config_name 'nsqkrakow'

  default :codec, 'json'

  config :nsqlookupd, :validate => :array, :default => 'http://localhost:4161'
  config :channel, :validate => :string, :default => 'logstash'
  config :topic, :validate => :string, :default => 'testtopic'
  config :max_in_flight, :validate => :number, :default => 150


  public
  def register
   @logger.info('Registering nsqkrakow', :channel => @channel, :topic => @topic, :nsqlookupd => @nsqlookupd)
   @consumer = Krakow::Consumer.new(
       nsqlookupd: @nsqlookupd,
       topic: @topic,
       channel: @channel,
       max_in_flight: @max_in_flight
   )
   # disabling this line will enable good debug output:
   Krakow::Utils::Logging.level = :warn
  end # def register

  public
  def run(logstash_queue)
    @logger.info('Running nsqkrakow', :channel => @channel, :topic => @topic, :nsqlookupd => @nsqlookupd)
    begin
      begin
       while true
          #@logger.info('consuming...')
          event = @consumer.queue.pop
          #@logger.warn('processing:', :event => event)
          queue_event(event.content, logstash_queue)
	  @consumer.confirm(event.message_id)
        end
      rescue LogStash::ShutdownSignal
        @logger.info('nsq got shutdown signal')
	@consumer.terminate
      end
      @logger.info('Done running nsqkrakow input')
    rescue => e
      @logger.warn('client threw exception, restarting',
                   :exception => e)
      retry
    end
    finished
  end # def run

  private
  def queue_event(body, output_queue)
    begin
        #@logger.info('processing:', :body => body)
	event = LogStash::Event.new("message" => body)  
	decorate(event)
	output_queue << event
    rescue => e # parse or event creation error
      @logger.error('Failed to create event', :message => "#{body}", :exception => e,
                    :backtrace => e.backtrace)
    end # begin
  end # def queue_event

end #class LogStash::Inputs::Nsqkrakow
