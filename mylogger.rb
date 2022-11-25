# frozen_string_literal: true

module Logging
    class MyLogger
      DEFAULTS = {
        level: :info
      }
  
      LEVELS = %w(debug info warn error fatal unknown).map(&:to_sym)
  
      def self.log(*tags, **params)
        level = determine_log_level(**params)
        params.delete(:level)
        message = build_message(*tags, **params)
  
        Rails.logger.send(level, message)
      end
  
      private
  
      def self.determine_log_level(**params)
        params.has_key?(:level) && params[:level].to_sym.in?(LEVELS) ? params[:level].to_sym : :info
      end
  
      def self.build_message(*tags, **params)
        tags.map!{ |tag| format_tag(tag) }
        params = params.map{ |args| format_param(args[0], args[1]) }
  
  
        tags.join(' ') + ' ' + params.join(' ')
      end
  
      def self.format_tag(tag)
        tag = tag.to_s.gsub(/[^\w]/i, '').upcase
        "[#{tag}]"
      end
  
      def self.format_param(key, value)
        key = key.to_s.gsub(/[^\w]/i, '').downcase
        value = value.to_s.gsub('"','')
  
        "#{key}=\"#{value}\""
      end
    end
  end
