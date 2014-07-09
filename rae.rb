require './parser.rb'
require 'typhoeus'


class Rae

  SEARCH_URL = 'http://lema.rae.es/drae/srv/search?val='
  BASE_EXTENSION = 'html'

  def search(word)
    Parser.new(query(word)).parse
  end

  private
  def query(word)
    raise 'NotImplemetedError'
  end
end


class FileRae < Rae
  private
  def query(file)
    IO.read("#{file}.{BASE_EXTENSION}}")
  end
end


class HTTPRae < Rae
  USER_AGENT = 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2049.0 Safari/537.36'

  private
  def query(word)
    `curl -s 'http://lema.rae.es/drae/srv/search?val=#{word}' \
    -H 'Pragma: no-cache'  \
    -H 'Origin: http://lema.rae.es' \
    -H 'Accept-Encoding: gzip,deflate,sdch' \
    -H 'Accept-Language: es-ES,es;q=0.8,en;q=0.6' \
    -H 'User-Agent: #{USER_AGENT}' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' \
    -H 'Cache-Control: no-cache' \
    -H 'Referer: http://lema.rae.es/drae/srv/search?val=#{word}' \
    -H 'Connection: keep-alive' \
    --form 'TS014dfc77_id=3&TS014dfc77_cr=42612abd48551544c72ae36bc40f440a%3Akkmj%3AQG60Q2v4%3A1477350835&TS014dfc77_76=0&TS014dfc77_md=1&TS014dfc77_rf=0&TS014dfc77_ct=0&TS014dfc77_pd=0' \
    --compressed`
  end
end



#puts FileRae.new.search('mocks/error')
puts HTTPRae.new.search(ARGV[0])


