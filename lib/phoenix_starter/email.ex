defmodule PhoenixStarter.Email do
  import Swoosh.Email

  # dynamic
  @mailer_conf Application.get_env(:phoenix_starter, PhoenixStarter.Mailer)
  @provider_options [:template_name, :custom_vars, :tags, :recipient_vars, :sending_options]

  def send_email(opts) when is_list(opts) do
    case Keyword.keyword?(opts) do
      true -> send_email(Enum.into(opts, %{}))
      false -> {:error, "email options must be a valid keyword list or map"}
    end
  end

  def send_email(opts) when is_map(opts) do
    email = get_email_struct(opts)
    # MailerTest.Mailer.deliver_now(email)
    email
  end

  defp get_email_struct(opts) do
    sender = get_sender(opts)
    receiver = Map.fetch!(opts, :to)
    subject = Map.get(opts, :subject, "")
    text = Map.get(opts, :text, "")

    new()
    |> from(sender)
    |> to(receiver)
    |> subject(@subject)
    |> text_body(text)
    |> parse_option(Map.to_list(opts))
  end

  def send_email(opts), do: {:error, "email options must be a valid keyword list or map"}

  defp get_sender(opts) do
    case Map.get(opts, :from, nil) do
      nil ->
        case @mailer_conf[:default_sender] do
          nil -> raise "missing `from:` value and `default_sender` is not set"
          default_sender -> default_sender
        end

      receiver ->
        receiver
    end
  end

  defp parse_option(email, [{k, v} | t])
       when k in [:template_name, :custom_vars, :tags] and not is_nil(v) do
    parse_option(put_provider_option(email, k, v), t)
  end

  # See https://hexdocs.pm/bamboo/Bamboo.Attachment.html to get an idea of what the value of the attachment could be
  defp parse_option(email, [{:attachments, v} | t]) when not is_nil(v) do
    attachment = Swoosh.Attachment.new(v)
    parse_option(attachment(email, attachment), t)
  end

  defp parse_option(email, [h | t]), do: parse_option(email, t)

  defp parse_option(email, nil), do: email
  defp parse_option(email, []), do: email
end
