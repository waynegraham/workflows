# frozen_string_literal: true

require_relative 'lib/utils'

FEED_URL = 'https://www.diglib.org/category/ndsa/feed/'

task default: %w[import:rss]

namespace :import do
  desc 'Import and convert NDSA feed into the posts directory'
  task :rss do
    Rss.import(FEED_URL)
  end
end
