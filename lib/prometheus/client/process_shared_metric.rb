require 'raindrops'
require 'prometheus/client/metric'
require 'prometheus/client/shared_storage'

module Prometheus
  module Client
    class ProcessSharedMetric < Metric
      def initialize(name, docstring, base_labels = {})
        super(name, docstring, base_labels)
        @values = ValueStore.new(name, default)
      end

      # returns all label sets with their values
      def values
        @values.each_with_object({}) do |(labels, value), memo|
          memo[labels] = value
        end
      end

      private

      class ValueStore
        include Enumerable

        def initialize(metric, default)
          @labelset_indexes = {}
          @metric = metric
          @default = default
        end

        def each
          @labelset_indexes.each do |label, index|
            yield label, SharedStorage::DROPS[index]
          end
        end

        def []=(labels, value)
          key = [@metric, labels].hash
          index = SharedStorage.set(key, value)
          @labelset_indexes[labels] = index
        end

        def [](labels)
          if @labelset_indexes.has_key?(labels)
            SharedStorage::DROPS[@labelset_indexes[labels]]
          else
            @default
          end
        end
      end
    end
  end
end
