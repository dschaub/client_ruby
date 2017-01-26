require 'raindrops'

module Prometheus
  module Client
    module SharedStorage
      DROPS = Raindrops.new 16

      def self.get(key, default)
        if key_indexes.has_key?(key)
          DROPS[key_indexes[key]]
        else
          default
        end
      end

      def self.set(key, value)
        if key_indexes.has_key?(key)
          DROPS[key_indexes[key]] = value

          key_indexes[key]
        else
          if key_indexes.size >= DROPS.size
            DROPS.size = DROPS.size * 2
          end

          index = key_indexes.size + 1
          key_indexes[key] = index
          DROPS[index] = value

          index
        end
      end

      def self.key_indexes
        @key_indexes ||= {}
      end
    end
  end
end
