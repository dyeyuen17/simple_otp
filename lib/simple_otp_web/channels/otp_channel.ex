defmodule SimpleOtpWeb.OtpChannel do
  use Phoenix.Channel
  alias SimpleOtp.Vaults

  intercept ["user_joined"]

  def join("otp_hub:vault", _message, socket) do
    {:ok, %{message: "You Suck!"}, socket}
  end

  def join("otp_hub:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("refresh_otp", %{"id" => id}, socket) do
    case Vaults.get_vault(id) do
      nil ->
        :ok

      vault ->
        otp_keys = generate_otp_keys(vault)
        broadcast!(socket, "refresh_otp_value", %{otp_keys: otp_keys})
    end

    {:noreply, socket}
  end

  def handle_in("refresh_otp", _payload, socket) do
    {:noreply, socket}
  end

  def refresh_otp do
    SimpleOtpWeb.Endpoint.broadcast("otp_hub:vault", "refresh_otp", %{})
  end

  def delayed_refresh_otp do
    Task.start(fn ->
      Process.sleep(30_000)
      SimpleOtpWeb.Endpoint.broadcast("otp_hub:vault", "refresh_otp", %{})
    end)
  end

  defp generate_otp_keys(vault) do
    vault
    |> Vaults.list_shells()
    |> Stream.map(&generate_otp/1)
    |> Enum.to_list()
  end

  defp generate_otp(shell) do
    %{id: shell.id, otp: :pot.totp(shell.secret)}
  end
end
