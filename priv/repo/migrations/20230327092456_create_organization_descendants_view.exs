defmodule STemplateAPI.Repo.Migrations.CreateOrganizationDescendantsView do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE FUNCTION organization_descendants(_id uuid) RETURNS TABLE(id uuid, name text, parent_organization_id uuid) AS $$
      --- SQL to get all the descendants of an organization

      WITH RECURSIVE tree AS (
        SELECT id, name, parent_organization_id FROM organizations WHERE id = _id

        UNION

        SELECT t.id, t.name, t.parent_organization_id FROM organizations t
          JOIN tree rt ON rt.id = t.parent_organization_id
      )
      SELECT * FROM tree;
    $$ LANGUAGE SQL;
    ;
    """
  end

  def down do
    execute """
    DROP FUNCTION organization_descendants;
    """
  end
end
