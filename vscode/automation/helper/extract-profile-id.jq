.userDataProfiles[]
| select(.name == $profile_name)
| .location
