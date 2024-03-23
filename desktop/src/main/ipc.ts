/**
 * @file Listen for IPC events sent/invoked by the renderer process, and route
 * them to their correct handlers.
 *
 * This file is meant as a sibling to `preload.ts`, but this one runs in the
 * context of the main process, and can import other files from `src/`.
 */

import { ipcMain } from "electron/main";
import { appVersion } from "../services/appUpdater";
import { openDirectory, openLogDirectory } from "./general";
import { logToDisk } from "./log";
import { fsExists } from "./fs";

// - General

export const attachIPCHandlers = () => {
    // Notes:
    //
    // The first parameter of the handler passed to `ipcMain.handle` is the
    // `event`, and is usually ignored. The rest of the parameters are the
    // arguments passed to `ipcRenderer.invoke`.
    //
    // [Note: Catching exception during .send/.on]
    //
    // While we can use ipcRenderer.send/ipcMain.on for one-way communication,
    // that has the disadvantage that any exceptions thrown in the processing of
    // the handler are not sent back to the renderer. So we use the
    // ipcRenderer.invoke/ipcMain.handle 2-way pattern even for things that are
    // conceptually one way. An exception (pun intended) to this is logToDisk,
    // which is a primitive, frequently used, operation and shouldn't throw, so
    // having its signature by synchronous is a bit convenient.

    // - General

    ipcMain.handle("appVersion", (_) => appVersion());

    ipcMain.handle("openDirectory", (_, dirPath) => openDirectory(dirPath));

    ipcMain.handle("openLogDirectory", (_) => openLogDirectory());

    // See: [Note: Catching exception during .send/.on]
    ipcMain.on("logToDisk", (_, msg) => logToDisk(msg));

    ipcMain.handle("fsExists", (_, path) => fsExists(path));
};
