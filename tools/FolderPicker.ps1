param(
    [Parameter(Position = 0)]
    [string] $InitialDirectory = "",

    [Parameter(Position = 1)]
    [string] $Title = "Select folder"
)

$ErrorActionPreference = "Stop"

$source = @'
using System;
using System.Runtime.InteropServices;

public static class NativeFolderPicker
{
    [Flags]
    private enum FOS : uint
    {
        FOS_PICKFOLDERS      = 0x00000020,
        FOS_FORCEFILESYSTEM  = 0x00000040,
        FOS_PATHMUSTEXIST    = 0x00000800,
        FOS_NOCHANGEDIR      = 0x00000008
    }

    private enum SIGDN : uint
    {
        FILESYSPATH = 0x80058000
    }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    private struct COMDLG_FILTERSPEC
    {
        [MarshalAs(UnmanagedType.LPWStr)]
        public string pszName;

        [MarshalAs(UnmanagedType.LPWStr)]
        public string pszSpec;
    }

    [ComImport]
    [Guid("DC1C5A9C-E88A-4DDE-A5A1-60F82A20AEF7")]
    private class FileOpenDialogRCW
    {
    }

    [ComImport]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    [Guid("42F85136-DB7E-439C-85F1-E4075D135FC8")]
    private interface IFileDialog
    {
        [PreserveSig]
        int Show(IntPtr parent);

        void SetFileTypes(
            uint cFileTypes,
            [MarshalAs(UnmanagedType.LPArray, SizeParamIndex = 0)]
            COMDLG_FILTERSPEC[] rgFilterSpec);

        void SetFileTypeIndex(uint iFileType);
        void GetFileTypeIndex(out uint piFileType);

        void Advise(IntPtr pfde, out uint pdwCookie);
        void Unadvise(uint dwCookie);

        void SetOptions(FOS fos);
        void GetOptions(out FOS pfos);

        void SetDefaultFolder(IShellItem psi);
        void SetFolder(IShellItem psi);
        void GetFolder(out IShellItem ppsi);
        void GetCurrentSelection(out IShellItem ppsi);

        void SetFileName([MarshalAs(UnmanagedType.LPWStr)] string pszName);
        void GetFileName([MarshalAs(UnmanagedType.LPWStr)] out string pszName);

        void SetTitle([MarshalAs(UnmanagedType.LPWStr)] string pszTitle);
        void SetOkButtonLabel([MarshalAs(UnmanagedType.LPWStr)] string pszText);
        void SetFileNameLabel([MarshalAs(UnmanagedType.LPWStr)] string pszLabel);

        void GetResult(out IShellItem ppsi);

        void AddPlace(IShellItem psi, int fdap);
        void SetDefaultExtension([MarshalAs(UnmanagedType.LPWStr)] string pszDefaultExtension);
        void Close(int hr);
        void SetClientGuid(ref Guid guid);
        void ClearClientData();
        void SetFilter(IntPtr pFilter);
    }

    [ComImport]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    [Guid("43826D1E-E718-42EE-BC55-A1E261C37BFE")]
    private interface IShellItem
    {
        void BindToHandler(
            IntPtr pbc,
            ref Guid bhid,
            ref Guid riid,
            out IntPtr ppv);

        void GetParent(out IShellItem ppsi);

        void GetDisplayName(
            SIGDN sigdnName,
            out IntPtr ppszName);

        void GetAttributes(
            uint sfgaoMask,
            out uint psfgaoAttribs);

        void Compare(
            IShellItem psi,
            uint hint,
            out int piOrder);
    }

    [DllImport("shell32.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
    private static extern void SHCreateItemFromParsingName(
        [MarshalAs(UnmanagedType.LPWStr)] string pszPath,
        IntPtr pbc,
        ref Guid riid,
        [MarshalAs(UnmanagedType.Interface)] out IShellItem ppv);

    public static string Pick(string initialDirectory, string title)
    {
        IFileDialog dialog = null;
        IShellItem initialItem = null;
        IShellItem resultItem = null;
        IntPtr pathPtr = IntPtr.Zero;

        try
        {
            dialog = (IFileDialog)new FileOpenDialogRCW();

            FOS options;
            dialog.GetOptions(out options);
            dialog.SetOptions(
                options |
                FOS.FOS_PICKFOLDERS |
                FOS.FOS_FORCEFILESYSTEM |
                FOS.FOS_PATHMUSTEXIST |
                FOS.FOS_NOCHANGEDIR);

            if (!String.IsNullOrWhiteSpace(title))
                dialog.SetTitle(title);

            if (!String.IsNullOrWhiteSpace(initialDirectory))
            {
                try
                {
                    Guid iidShellItem = new Guid("43826D1E-E718-42EE-BC55-A1E261C37BFE");
                    SHCreateItemFromParsingName(
                        initialDirectory,
                        IntPtr.Zero,
                        ref iidShellItem,
                        out initialItem);

                    if (initialItem != null)
                        dialog.SetFolder(initialItem);
                }
                catch
                {
                    // Invalid/unavailable initial path: show the dialog normally.
                }
            }

            int hr = dialog.Show(IntPtr.Zero);

            // HRESULT_FROM_WIN32(ERROR_CANCELLED) = 0x800704C7
            if (hr == unchecked((int)0x800704C7))
                return null;

            if (hr < 0)
                Marshal.ThrowExceptionForHR(hr);

            dialog.GetResult(out resultItem);
            if (resultItem == null)
                return null;

            resultItem.GetDisplayName(SIGDN.FILESYSPATH, out pathPtr);
            if (pathPtr == IntPtr.Zero)
                return null;

            return Marshal.PtrToStringUni(pathPtr);
        }
        finally
        {
            if (pathPtr != IntPtr.Zero)
                Marshal.FreeCoTaskMem(pathPtr);

            if (resultItem != null)
                Marshal.FinalReleaseComObject(resultItem);

            if (initialItem != null)
                Marshal.FinalReleaseComObject(initialItem);

            if (dialog != null)
                Marshal.FinalReleaseComObject(dialog);
        }
    }
}
'@

try {
    Add-Type -TypeDefinition $source -Language CSharp
    $selected = [NativeFolderPicker]::Pick($InitialDirectory, $Title)

    if ([String]::IsNullOrWhiteSpace($selected)) {
        exit 1
    }

    [Console]::Out.WriteLine($selected)
    exit 0
}
catch {
    [Console]::Error.WriteLine($_.Exception.ToString())
    exit 2
}
