defmodule FindMyLocatorGraphQL do
  @moduledoc false

  alias Absinthe.Pipeline
  alias FindMyLocatorGraphQL.Middleware

  def configuration do
    [
      document_providers: [Absinthe.Plug.DocumentProvider.Default],
      json_codec: Phoenix.json_library(),
      schema: FindMyLocatorGraphQL.Schema,
      pipeline: {__MODULE__, :absinthe_pipeline}
    ]
  end

  def absinthe_pipeline(config, options) do
    options = build_options(options)

    config
    |> Absinthe.Plug.default_pipeline(options)
    |> Pipeline.insert_after(Absinthe.Phase.Document.Complexity.Result, {AbsintheSecurity.Phase.IntrospectionCheck, options})
    |> Pipeline.insert_after(Absinthe.Phase.Document.Complexity.Result, {AbsintheSecurity.Phase.MaxAliasesCheck, options})
    |> Pipeline.insert_after(Absinthe.Phase.Document.Complexity.Result, {AbsintheSecurity.Phase.MaxDepthCheck, options})
    |> Pipeline.insert_after(Absinthe.Phase.Document.Complexity.Result, {AbsintheSecurity.Phase.MaxDirectivesCheck, options})
    |> Pipeline.insert_before(Absinthe.Phase.Document.Result, Middleware.OperationNameLogger)
    |> Pipeline.insert_after(Absinthe.Phase.Document.Result, {AbsintheSecurity.Phase.FieldSuggestionsCheck, options})
    |> Pipeline.insert_after(Absinthe.Phase.Document.Result, Middleware.ErrorReporting)
  end

  defp build_options(options) do
    Keyword.merge(
      [
        token_limit: Application.get_env(:find_my_locator, FindMyLocatorGraphQL)[:token_limit]
      ],
      Pipeline.options(options)
    )
  end
end
