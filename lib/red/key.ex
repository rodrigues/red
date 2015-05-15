defprotocol Red.Key do
  @spec build(Red.Key.t) :: String.t
  def build(x)
end
