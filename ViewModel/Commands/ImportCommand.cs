using LaPalace.ViewModel.FileOperations;
using System;
using System.Drawing;
using System.Windows.Input;

namespace LaPalace.ViewModel.Commands
{
    public class ImportCommand : ICommand
    {
        public LaPalaceVM VM { get; set; }

        public ImportCommand(LaPalaceVM vm) => VM = vm;

        public event EventHandler CanExecuteChanged
        {
            add
            {
                CommandManager.RequerySuggested += value;
            }
            remove
            {
                CommandManager.RequerySuggested -= value;
            }
        }

        public bool CanExecute(object parameter) => true;

        public void Execute(object parameter)
        {
            ImportFile();
        }

        public void ImportFile()
        {
            string newImagePath = FileOpener.OpenFile();
            if (VM.ImagePath != newImagePath)
            {
                VM.ImagePath = newImagePath;
                try
                {
                    VM.InputImage = new Bitmap(VM.ImagePath);
                }
                catch { }
            }
        }
    }
}
