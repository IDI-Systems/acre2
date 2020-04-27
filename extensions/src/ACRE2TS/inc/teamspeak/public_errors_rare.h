#ifndef PUBLIC_ERRORS__RARE_H
#define PUBLIC_ERRORS__RARE_H

//The idea here is: the values are 2 bytes wide, the first byte identifies the group, the second the count within that group

enum Ts3RareErrorType {
    //client
    ERROR_client_invalid_password                = 0x0208,
    ERROR_client_too_many_clones_connected       = 0x0209,
    ERROR_client_is_online                       = 0x020b,

    //channel
    ERROR_channel_is_private_channel             = 0x030e,
    //note 0x030f is defined in public_errors;

    //database
    ERROR_database                               = 0x0500,
    ERROR_database_empty_result                  = 0x0501,
    ERROR_database_duplicate_entry               = 0x0502,
    ERROR_database_no_modifications              = 0x0503,
    ERROR_database_constraint                    = 0x0504,
    ERROR_database_reinvoke                      = 0x0505,

    //permissions
    ERROR_permission_invalid_group_id            = 0x0a00,
    ERROR_permission_duplicate_entry             = 0x0a01,
    ERROR_permission_invalid_perm_id             = 0x0a02,
    ERROR_permission_empty_result                = 0x0a03,
    ERROR_permission_default_group_forbidden     = 0x0a04,
    ERROR_permission_invalid_size                = 0x0a05,
    ERROR_permission_invalid_value               = 0x0a06,
    ERROR_permissions_group_not_empty            = 0x0a07,
    ERROR_permissions_insufficient_group_power   = 0x0a09,
    ERROR_permissions_insufficient_permission_power = 0x0a0a,
    ERROR_permission_template_group_is_used      = 0x0a0b,
    //0x0a0c is in public_errors.h
    ERROR_permission_used_by_integration         = 0x0a0d,

    //server
    ERROR_server_deployment_active               = 0x0405,
    ERROR_server_unable_to_stop_own_server       = 0x0406,
    ERROR_server_wrong_machineid                 = 0x0408,
    ERROR_server_modal_quit                      = 0x040c,
    ERROR_server_time_difference_too_large       = 0x040f,
    ERROR_server_blacklisted                     = 0x0410,
    ERROR_server_shutdown                        = 0x0411,

    //messages
    ERROR_message_invalid_id                     = 0x0c00,

    //ban
    ERROR_ban_invalid_id                         = 0x0d00,
    ERROR_connect_failed_banned                  = 0x0d01,
    ERROR_rename_failed_banned                   = 0x0d02,
    ERROR_ban_flooding                           = 0x0d03,

    //tts
    ERROR_tts_unable_to_initialize               = 0x0e00,

    //privilege key
    ERROR_privilege_key_invalid                  = 0x0f00,

    //voip
    ERROR_voip_pjsua                             = 0x1000,
    ERROR_voip_already_initialized               = 0x1001,
    ERROR_voip_too_many_accounts                 = 0x1002,
    ERROR_voip_invalid_account                   = 0x1003,
    ERROR_voip_internal_error                    = 0x1004,
    ERROR_voip_invalid_connectionId              = 0x1005,
    ERROR_voip_cannot_answer_initiated_call      = 0x1006,
    ERROR_voip_not_initialized                   = 0x1007,

    //ed25519
    ERROR_ed25519_rng_fail                       = 0x1300,
    ERROR_ed25519_signature_invalid              = 0x1301,
    ERROR_ed25519_invalid_key                    = 0x1302,
    ERROR_ed25519_unable_to_create_valid_key     = 0x1303,
    ERROR_ed25519_out_of_memory                  = 0x1304,
    ERROR_ed25519_exists                         = 0x1305,
    ERROR_ed25519_read_beyond_eof                = 0x1306,
    ERROR_ed25519_write_beyond_eof               = 0x1307,
    ERROR_ed25519_version                        = 0x1308,
    ERROR_ed25519_invalid                        = 0x1309,
    ERROR_ed25519_invalid_date                   = 0x130A,
    ERROR_ed25519_unauthorized                   = 0x130B,
    ERROR_ed25519_invalid_type                   = 0x130C,
    ERROR_ed25519_address_nomatch                = 0x130D,
    ERROR_ed25519_not_valid_yet                  = 0x130E,
    ERROR_ed25519_expired                        = 0x130F,
    ERROR_ed25519_index_out_of_range             = 0x1310,
    ERROR_ed25519_invalid_size                   = 0x1311,

    //mytsid - client
    ERROR_invalid_mytsid_data                    = 0x1200,
    ERROR_invalid_integration                    = 0x1201,
};

#endif
