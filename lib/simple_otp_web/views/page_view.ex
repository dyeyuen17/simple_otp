defmodule SimpleOtpWeb.PageView do
  use SimpleOtpWeb, :view

  def sort_vaults(vaults) do
    vaults
    |> Stream.chunk_every(3)
    |> Enum.to_list()
  end

  def sort_shells(shells) do
    shells
    |> Stream.chunk_every(3)
    |> Enum.to_list()
  end

  def icon(conn, filename) do
    Routes.static_path(conn, "/images/#{filename}")
  end

  def render_totp(secret) do
    :pot.totp(secret)
  end

  def generate_qr(shell) do
    shell
    |> generate_uri()
    |> EQRCode.encode()
    |> EQRCode.svg(color: "#0d92c6", shape: "circle", width: 230)
  end

  def generate_uri(%{email: email, name: name, secret: secret})
   when not is_nil(email) do
    "otpauth://totp/#{name}:#{name}%20(#{email})?secret=#{secret}"
  end

  def generate_uri(%{username: username, name: name, secret: secret})
   when not is_nil(username) do
    "otpauth://totp/#{name}:#{name}%20(#{username})?secret=#{secret}"
  end

  def generate_uri(%{name: name, secret: secret}) do
    "otpauth://totp/#{name}:#{name}?secret=#{secret}"
  end
end
