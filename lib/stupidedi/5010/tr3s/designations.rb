
#
# Industry Usage
#   REQUIRED
#     This structure must always be sent when the parent structure is sent
#
#   NOT_USED
#     This structure must never be sent
#
#   SITUATIONAL
#     Use of this structure varies, depending on the documented situational rule
#     of which there are two kinds.
#
#     The first form is "Required when <condition>; If not required by this
#     implementation guide, may be provided at the sender's discretion, but
#     cannot be required by the receiver."
#
#                       Sent   Not Sent
#         <condition> +------+----------
#                   T |   +  |  -
#                   F |  (+) |  +
#
#     The second form is "required when <condition>; If not required by this
#     implementation guide, do not send."
#
#                       Sent   Not Sent
#         <condition> +------+----------
#                   T |   +  |  -
#                   F |  (-) |  +
#
