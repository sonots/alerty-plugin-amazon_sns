require 'alerty'
require 'aws-sdk'
require 'dotenv'
Dotenv.load

class Alerty
  class Plugin
    class AmazonSns
      def initialize(config)
        raise ConfigError.new('amazon_sns: topic_arn is not configured') unless config.topic_arn
        raise ConfigError.new('amazon_sns: subject is not configured') unless config.subject
        # see http://docs.aws.amazon.com/sdkforruby/api/Aws/SNS/Client.html
        # ENV or ~/.aws/credentials or instance profile on EC2, or alerty config file
        params = {}
        params[:region] = config.aws_region || guess_region(config.topic_arn)
        params[:access_key_id] = config.aws_access_key_id if config.aws_access_key_id
        params[:secret_access_key] = config.aws_secret_access_key if config.aws_secret_access_key
        @client = Aws::SNS::Client.new(params)
        @subject = config.subject
        @message = config.message
        @topic_arn = config.topic_arn
        @num_retries = config.num_retries || 3
      end

      def alert(record)
        subject = get_subject(record)
        message = get_message(record)
        retries = 0
        begin
          @client.publish(topic_arn: @topic_arn, message: message, subject: subject)
          Alerty.logger.info "Sent #{{subject: subject, message: message}} to #{@topic_arn}"
        rescue => e
          retries += 1
          sleep 1
          if retries <= @num_retries
            retry
          else
            raise e
          end
        end
      end

      private

      def get_message(record)
        message = @message.nil? ? record[:output] : expand_placeholder(@message, record)
        message = ' ' if message.empty? # SNS constraint, SNS errors if message is empty
        message
      end

      def get_subject(record)
        subject = expand_placeholder(@subject, record)
        subject = subject[0..98] # SNS constraint, must be less than 100 character long
      end

      def guess_region(topic_arn)
        # arn:aws:sns:ap-northeast-1:<account_id>:<topic_name>
        topic_arn.split(':')[3]
      end

      def expand_placeholder(str, record)
        replaced = str.gsub('${command}', record[:command])
        replaced.gsub!('${hostname}', record[:hostname])
        replaced.gsub!('${output}', record[:output])
        replaced
      end
    end
  end
end
