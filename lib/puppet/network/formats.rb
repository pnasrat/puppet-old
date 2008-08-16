require 'puppet/network/format_handler'

Puppet::Network::FormatHandler.create(:yaml, :mime => "text/yaml") do
    # Yaml doesn't need the class name; it's serialized.
    def intern(klass, text)
        YAML.load(text)
    end

    # Yaml doesn't need the class name; it's serialized.
    def intern_multiple(klass, text)
        YAML.load(text)
    end

    def render(instance)
        instance.to_yaml
    end

    # Yaml monkey-patches Array, so this works.
    def render_multiple(instances)
        instances.to_yaml
    end

    # Everything's supported
    def supported?(klass)
        true
    end
end


Puppet::Network::FormatHandler.create(:marshal, :mime => "text/marshal") do
    # Marshal doesn't need the class name; it's serialized.
    def intern(klass, text)
        Marshal.load(text)
    end

    # Marshal doesn't need the class name; it's serialized.
    def intern_multiple(klass, text)
        Marshal.load(text)
    end

    def render(instance)
        Marshal.dump(instance)
    end

    # Yaml monkey-patches Array, so this works.
    def render_multiple(instances)
        Marshal.dump(instances)
    end

    # Everything's supported
    def supported?(klass)
        true
    end
end

Puppet::Network::FormatHandler.create(:str, :mime => "text/plain") do
    # For now, use the YAML separator.
    SEPARATOR = "\n---\n"

    def intern_multiple(klass, text)
        text.split(SEPARATOR).collect { |inst| intern(klass, inst) }
    end

    def render_multiple(instances)
        instances.collect { |inst| render(inst) }.join(SEPARATOR)
    end

    # Everything's supported
    def supported?(klass)
        true
    end
end
