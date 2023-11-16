# frozen_string_literal: true

require 'teLogger'
require 'toolrack'

require_relative "roqs/version"

module Roqs
  include TR::CondUtils

  # OQS_STATUS
  OQS_ERROR = -1
  OQS_SUCCESS = 0
  OQS_EXTERNAL_LIB_ERROR_OPENSSL = 50

  class Error < StandardError; end
  # Your code goes here...

  def self.logger(tag = nil, &block)
    @_logger = TeLogger::Tlogger.new if @_logger.nil?

    if block
      if not_empty?(tag)
        @_logger.with_tag(tag, &block)
      else
        @_logger.with_tag(@_logger.tag, &block)
      end
    elsif is_empty?(tag)
      @_logger.tag = :roqs
      @_logger
    else
      # no block but tag is given? hmm
      @_logger.tag = tag
      @_logger
    end
  end

end

require_relative "roqs/struct"
require_relative "roqs/kem"
require_relative "roqs/sig"
