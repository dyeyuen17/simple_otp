defmodule SimpleOtpWeb.PageController do
  use SimpleOtpWeb, :controller

  alias Argon2
  alias SimpleOtp.Accounts
  alias SimpleOtp.Accounts.User
  alias SimpleOtp.Vaults
  alias SimpleOtpWeb.Services.Guardian

  def index(conn, _) do
    if Guardian.Plug.current_resource(conn) do
      redirect(conn, to: Routes.page_path(conn, :dashboard))
    else
      render(conn, "index.html")
    end
  end

  def dashboard(conn, _) do
    vaults = Vaults.list_vaults(conn.assigns[:current_user])
    render(conn, "dashboard.html", vaults: vaults)
  end

  def new(conn, _) do
    changeset = User.create_changeset(%User{}, %{})

    if Guardian.Plug.current_resource(conn) do
      redirect(conn, to: Routes.page_path(conn, :dashboard))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def sign_up(conn, %{"user" => params}) do
    case Accounts.create_user(params) do
      {:ok, _user} ->
        render(conn, "index.html")

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def sign_in(conn, %{"username" => username, "password" => password}) do
    authenticate_user(username, password)
    |> login(conn)
  end

  def sign_out(conn, _) do
    logout(conn)
  end

  def logout(conn) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp login({:ok, user}, conn) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> put_session(:current_user, user)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp login({:error, reason}, conn) do
    conn
    |> put_flash(:error, reason)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp authenticate_user(username, password) do
    case Accounts.get_user_by_field(:username, username) do
      nil ->
        Argon2.no_user_verify()
        {:error, "User not found"}

      %{hashed_password: hashed_password} = user ->
        if Argon2.verify_pass(password, hashed_password) do
          {:ok, user}
        else
          {:error, "Incorrect password"}
        end
    end
  end

  def create_vault(%{assigns: %{current_user: user}} = conn, params) do
    case Vaults.create_vault(user, params) do
      {:ok, _vault} ->
        redirect(conn, to: Routes.page_path(conn, :index))

      {:error, _changeset} ->
        redirect(conn, to: Routes.page_path(conn, :index))
    end
  end

  def edit_vault(conn, %{"id" => vault_id} = params) do
    require IEx
    IEx.pry()
  end

  def shells(conn, %{"id" => vault_id}) do
    case Vaults.get_vault(vault_id) do
      nil ->
        redirect(conn, to: Routes.page_path(conn, :index))

      vault ->
        shells = Vaults.list_shells(vault)
        render(conn, "shells.html", shells: shells, vault: vault)
    end
  end

  def shell(conn, %{"id" => shell_id}) do
    case Vaults.get_shell(shell_id, :vault) do
      nil ->
        redirect(conn, to: Routes.page_path(conn, :shells))

      shell ->
        render(conn, "shell.html", shell: shell)
    end
  end

  def create_shell(conn, %{"id" => id} = params) do
    case Vaults.get_vault(id) do
      nil ->
        redirect(conn, to: Routes.page_path(conn, :index))

      vault ->
        case Vaults.create_shell(vault, params) do
          {:ok, _vault} ->
            redirect(conn, to: Routes.page_path(conn, :shells, vault.id))

          {:error, _changeset} ->
            shells = Vaults.list_shells(vault)

            conn
            |> put_flash(:error, "Error in creating shell. Double check secret")
            |> render("shells.html", vault: vault, shells: shells)
        end
    end
  end
end
