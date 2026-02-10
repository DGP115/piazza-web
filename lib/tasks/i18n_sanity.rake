namespace :i18n do
  desc "Fail if any translation key resolves to an empty hash"
  task sanity: :environment do
    empty_keys = []

    walk = lambda do |hash, prefix|
      hash.each do |key, value|
        full_key = [ prefix, key ].compact.join(".")

        if value.is_a?(Hash)
          if value.empty?
            empty_keys << full_key
          else
            walk.call(value, full_key)
          end
        end
      end
    end

    I18n.available_locales.each do |locale|
      data = I18n.backend.send(:translations)[locale]
      walk.call(data, locale.to_s)
    end

    if empty_keys.any?
      puts "\n❌ Empty I18n translation hashes detected:\n\n"
      empty_keys.each { |k| puts "  - #{k}" }
      puts "\nThese will break pluralization and must be removed.\n"
      exit 1
    else
      puts "✅ I18n sanity check passed — no empty translation hashes found"
    end
  end
end
