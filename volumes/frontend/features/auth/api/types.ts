export type CurrentUser = {
  name: string
  email: string
}

export type CurrentUserResponse = {
  currentUser: CurrentUser | null
}
