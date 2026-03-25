
--
        
DECLARE
  l_roles     OWA.VC_ARR;
  l_modules   OWA.VC_ARR;
  l_patterns  OWA.VC_ARR;

BEGIN
  ORDS.ENABLE_SCHEMA(
      p_enabled             => TRUE,
      p_url_mapping_type    => 'BASE_PATH',
      p_url_mapping_pattern => 'wksp_elwagha50',
      p_auto_rest_auth      => TRUE);

  ORDS.CREATE_ROLE(
      p_role_name=> 'oracle.dbtools.role.autorest.WKSP_ELWAGHA50');
  ORDS.CREATE_ROLE(
      p_role_name=> 'oracle.dbtools.role.autorest.any.WKSP_ELWAGHA50');
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
  l_roles(2) := 'oracle.dbtools.role.autorest.WKSP_ELWAGHA50';
  l_patterns(1) := '/metadata-catalog/*';

  ORDS.DEFINE_PRIVILEGE(
      p_privilege_name => 'oracle.dbtools.autorest.privilege.WKSP_ELWAGHA50',
      p_roles          => l_roles,
      p_patterns       => l_patterns,
      p_modules        => l_modules,
      p_label          => 'WKSP_ELWAGHA50 metadata-catalog access',
      p_description    => 'Provides access to the metadata catalog of the objects in the WKSP_ELWAGHA50 schema.',
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


-- sqlcl_snapshot {"hash":"d249a0c54c4fb814a935a973f301b9ec7b3c6f23","type":"ORDS_SCHEMA","name":"ords","schemaName":"WKSP_ELWAGHA50","sxml":""}