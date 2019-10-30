defmodule SimpleOtpWeb.PageView do
  use SimpleOtpWeb, :view

  # this module is for testing randomly generated qr_code

  def generate_qr_code() do
    require Logger;

    otp = "totp"
    app_name = "Simpleotp"
    app_slug = "Simpleotp"
    email = "x123x@mailinator.com" |> String.replace("@", "%40")
    secret = OneTimePassEcto.Base.gen_secret(32)

    qr_uri = "otpauth://#{otp}/#{app_name}:#{email}?secret=#{secret}"
      <>"&issuer=#{app_slug}&algorithm=SHA1&digits=6&period=30"

    qr_uri
    |> EQRCode.encode()
    |> EQRCode.svg(color: "#cd07e3", width: 300)
  end
end
