-- liquibase formatted sql
-- changeset DEV_SCHEMA:1774464142500 stripComments:false  logicalFilePath:ords/dev_schema/ords.sql
-- sqlcl_snapshot {"hash":"995dc0b750bc0b072b39296c8562a16b88452856","type":"ORDS_SCHEMA","name":"ords","schemaName":"DEV_SCHEMA","sxml":""}
--
        
DECLARE
  l_roles     OWA.VC_ARR;
  l_modules   OWA.VC_ARR;
  l_patterns  OWA.VC_ARR;

BEGIN
  ORDS.ENABLE_SCHEMA(
      p_enabled             => TRUE,
      p_url_mapping_type    => 'BASE_PATH',
      p_url_mapping_pattern => 'dev_schema',
      p_auto_rest_auth      => TRUE);

  ORDS.CREATE_ROLE(
      p_role_name=> 'oracle.dbtools.role.autorest.DEV_SCHEMA');
  ORDS.CREATE_ROLE(
      p_role_name=> 'oracle.dbtools.role.autorest.any.DEV_SCHEMA');
  l_roles(1) := 'oracle.dbtools.auth.roles.builtin.VecDB';
  l_patterns(1) := '/vecdb/*';

  ORDS.DEFINE_PRIVILEGE(
      p_privilege_name => 'oracle.dbtools.auth.privileges.builtin.VecDB',
      p_roles          => l_roles,
      p_patterns       => l_patterns,
      p_modules        => l_modules,
      p_label          => NULL,
      p_description    => NULL,
      p_comments       => NULL); 

  l_roles.DELETE;
  l_modules.DELETE;
  l_patterns.DELETE;

  l_roles(1) := 'oracle.dbtools.autorest.any.schema';
  l_roles(2) := 'oracle.dbtools.role.autorest.DEV_SCHEMA';
  l_patterns(1) := '/metadata-catalog/*';

  ORDS.DEFINE_PRIVILEGE(
      p_privilege_name => 'oracle.dbtools.autorest.privilege.DEV_SCHEMA',
      p_roles          => l_roles,
      p_patterns       => l_patterns,
      p_modules        => l_modules,
      p_label          => 'DEV_SCHEMA metadata-catalog access',
      p_description    => 'Provides access to the metadata catalog of the objects in the DEV_SCHEMA schema.',
      p_comments       => NULL); 

  l_roles.DELETE;
  l_modules.DELETE;
  l_patterns.DELETE;

  l_roles(1) := 'SODA Developer';
  l_patterns(1) := '/soda/*';

  ORDS.DEFINE_PRIVILEGE(
      p_privilege_name => 'oracle.soda.privilege.developer',
      p_roles          => l_roles,
      p_patterns       => l_patterns,
      p_modules        => l_modules,
      p_label          => NULL,
      p_description    => NULL,
      p_comments       => NULL); 

  l_roles.DELETE;
  l_modules.DELETE;
  l_patterns.DELETE;


COMMIT;

END;
/


