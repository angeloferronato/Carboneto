export type Creator = Pick<UserData, "Name" | "ProfilePicture"> & {
    IsVerified: boolean,
}

export interface UserData {
    Name: string;
    ProfilePicture: string;
    Username: string;
    [key: string]: any;
}

export interface ExerciseData {
    Title: string;
    Duration: any;
    Repetitions: any;
    Creator: Creator;
    Thumbnail: string;
    Type: string;
    AuthorID: string,
    Categories: Array<string>,
    Description: string,
    ID: string,
    Video: string,
    [key: string]: any,
}