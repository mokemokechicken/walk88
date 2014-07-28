class UserPin
  def initialize(id, image_url)
    @id = id
    @image = image_url
  end

  def pin
    cache = ActiveSupport::Cache.lookup_store(:file_store, 'tmp/as_cache')
    data = cache.read("user_pic/#{@id}")
    return data if data
    return cache.read("user_pic/#{@id}") if update
    nil
  end

  def update
    cache = ActiveSupport::Cache.lookup_store(:file_store, 'tmp/as_cache')

    res = get_data(@image)
    return false unless res['last-modified']

    time_prev = cache.read("user_pic_last_modified/#{@id}").to_i
    time_curr = Time.rfc2822(res['last-modified']).to_i
    return false if time_curr <= time_prev

    # need to update image cache
    cache.write("user_pic_last_modified/#{@id}", time_curr)
    cache.write("user_pic/#{@id}", generate(res.body))
    true
  end

  private
  def generate(data)
    mask_path = Rails.root.join('app', 'assets', 'images', 'mask.png').to_s
    pin_path = Rails.root.join('app', 'assets', 'images', 'pin.png').to_s

    pic = Magick::ImageList.new.from_blob(data).first
    pin = Magick::ImageList.new(pin_path).first
    tmp = Magick::ImageList.new(mask_path)
    tmp.alpha = Magick::ActivateAlphaChannel
    mask = tmp.fx('1-r', Magick::AlphaChannel)
    mpic = mask.composite(pic, 0, 0, Magick::SrcInCompositeOp)
    ret = pin.composite(mpic, 2, 2, Magick::OverCompositeOp)
    ret.to_blob
  end

  def get_data(url)
    uri = url.kind_of?(URI) ? url : URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == 'https'
    http.start do |io|
      res = io.get(uri.request_uri)
      if res.code == '302'
        return get_data(res['Location'])
      else
        return res
      end
    end
  end
end
