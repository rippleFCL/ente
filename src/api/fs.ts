import { getElectronFile, getDirFilePaths } from '../services/fs';

export async function getDirFiles(dirPath: string) {
    const files = await getDirFilePaths(dirPath);
    const electronFiles = await Promise.all(files.map(getElectronFile));
    return electronFiles;
}
export {
    isFolder,
    moveFile,
    deleteFolder,
    deleteFile,
    rename,
    readTextFile,
} from '../services/fs';
