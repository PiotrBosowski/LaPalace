using System;
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
            VM.ImportFile();
        }
    }
}
