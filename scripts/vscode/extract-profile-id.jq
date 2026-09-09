.userDataProfiles[]
| select(.name == $profile)
| .location
