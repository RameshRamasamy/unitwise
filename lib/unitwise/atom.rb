module Unitwise
  class Atom < Base
    attr_accessor :classification, :property, :metric, :special
    attr_accessor :arbitrary, :function, :dim

    include Unitwise::Composable

    class << self
      def data
        @data ||= data_files.reduce([]){|m,f| m += YAML::load File.open(f)}
      end

      def data_files
        %w(base_unit derived_unit).map{|type| Unitwise.data_file type}
      end
    end

    def base?
      scale.nil? && !dim.nil?
    end

    def derived?
      !base?
    end

    def metric?
      base? ? true : !!metric
    end

    def special?
      !!special
    end

    def arbitrary?
      !!arbitrary
    end

    def dimless?
      classification == 'dimless'
    end

    def root?
      base? || dimless?
    end

    def key
      base? ? dim : property
    end

    def scale=(*args)
      if args.first.is_a?(Hash)
        hash = args.first
        @scale = Scale.new(hash[:value], hash[:unit_code])
      else
        @scale = Scale.new(*args)
      end
    end

    def scale_class
      Scale
    end

    def root_terms
      scale.root_terms unless root?
    end

  end
end