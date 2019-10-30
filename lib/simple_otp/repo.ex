defmodule SimpleOtp.Repo do
  use Ecto.Repo,
    otp_app: :simple_otp,
    adapter: Ecto.Adapters.Postgres
end
