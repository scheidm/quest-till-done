class Color < ActiveRecord::Base
  self.inheritance_column = nil
  def create_color(object)
    self.type= object.class.name.demodulize
    self.related_id=object.id
    self.generate_color(object)
    self.save
  end
  def generate_color(object)
    mask=0xFFFFFF
    mask=0xCCCCCC if self.type=="campaign"
    d=Digest::MD5.hexdigest(object.name)
    x=(Integer("0x#{d}")& mask)
    y= sprintf("%06x",x)
    self.color_hex=y
  end
end
