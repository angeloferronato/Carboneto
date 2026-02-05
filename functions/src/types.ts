export interface Creator {
    Name: string,
    ProfilePicture: string,
    IsVerified: boolean,
}

export interface UserData {
    Name: string;
    ProfilePicture: string;
    Username: string;
    [key: string]: any;
}