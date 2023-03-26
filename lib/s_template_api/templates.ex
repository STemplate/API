defmodule STemplateAPI.Templates do
  @moduledoc """
  The Templates context.
  """

  import Ecto.Query, warn: false

  alias STemplateAPI.Repo
  alias STemplateAPI.Templates.{Template, Version}

  ###########################################################################
  # Templates
  ###########################################################################

  @doc """
  Returns the list of templates.

  ## Examples

      iex> list_templates()
      [%Template{}, ...]

  """
  def list_templates do
    Repo.all(Template)
  end

  @doc """
  Gets a single template.

  ## Examples

      iex> get_template(123)
      {:ok, %Template{}}

      iex> get_template(456)
      {:error, :not_found}

  """
  def get_template(id) do
    case Repo.get(Template, id) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end

  @doc """
  Gets a single template by name.
  """
  def get_template_by_name(name) do
    Template |> Repo.get_by(name: name)
  end

  @doc """
  Creates a template.

  ## Examples

      iex> create_template(%{field: value})
      {:ok, %Template{}}

      iex> create_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_template(attrs \\ %{}) do
    %Template{}
    |> Template.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a template.

  ## Examples

      iex> update_template(template, %{field: new_value})
      {:ok, %Template{}}

      iex> update_template(template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_template(%Template{} = template, attrs), do: do_update_template(template, attrs)

  # template content was modified. Let's create a new version
  defp do_update_template(template, %{"template" => content} = attrs)
       when template.template != content do
    version_changeset =
      %Version{} |> Version.changeset(%{content: template.template, template_id: template.id})

    r =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:version, version_changeset)
      |> Ecto.Multi.update(:template, template |> Template.changeset(attrs))
      |> Repo.transaction()

    case r do
      {:ok, %{template: template}} -> {:ok, template}
      {:error, _, error, _} -> {:error, error}
    end
  end

  defp do_update_template(template, attrs) do
    template
    |> Template.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a template.

  ## Examples

      iex> delete_template(template)
      {:ok, %Template{}}

      iex> delete_template(template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_template(%Template{} = template) do
    Repo.delete(template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking template changes.

  ## Examples

      iex> change_template(template)
      %Ecto.Changeset{data: %Template{}}

  """
  def change_template(%Template{} = template, attrs \\ %{}) do
    Template.changeset(template, attrs)
  end

  ###########################################################################
  # Versions
  ###########################################################################

  @doc """
  Gets a single version.

  ## Examples

      iex> get_version(123)
      {:ok, %Version{}}

      iex> get_version(456)
      {:error, :not_found}

  """
  def get_version(id) do
    case Repo.get(Version, id) do
      nil -> {:error, :not_found}
      result -> {:ok, result}
    end
  end

  @doc """
  Deletes a version.

  ## Examples

      iex> delete_version(version)
      {:ok, %Version{}}

      iex> delete_version(version)
      {:error, %Ecto.Changeset{}}

  """
  def delete_version(%Version{} = version) do
    Repo.delete(version)
  end

  # @doc """
  # Returns an `%Ecto.Changeset{}` for tracking version changes.

  # ## Examples

  #     iex> change_version(version)
  #     %Ecto.Changeset{data: %Version{}}

  # """
  # def change_version(%Version{} = version, attrs \\ %{}) do
  #   Version.changeset(version, attrs)
  # end
end
