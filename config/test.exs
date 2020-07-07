use Mix.Config

# Configure your database
config :simple_otp, SimpleOtp.Repo,
  username: "postgres",
  password: "postgres",
  database: "simple_otp_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
  
if System.get_env("GITHUB_ACTIONS") do
  config :simple_otp, SimpleOtp.Repo,
    username: "postgres",
    password: "postgres"
end

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :simple_otp, SimpleOtpWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
