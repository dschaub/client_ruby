# encoding: UTF-8

require 'prometheus/client/process_shared_metric'

module Prometheus
  module Client
    # Counter is a metric that exposes merely a sum or tally of things.
    class Counter < ProcessSharedMetric
      def type
        :counter
      end

      def increment(labels = {}, by = 1)
        raise ArgumentError, 'increment must be a non-negative number' if by < 0

        label_set = label_set_for(labels)
        @values[label_set] += by
      end

      private

      def default
        0
      end
    end
  end
end
