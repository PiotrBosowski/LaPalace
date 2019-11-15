using System;
using System.Windows.Input;

namespace LaPalace.ViewModel.Commands
{
    public class SaveCommand : ICommand
    {
        private LaPalaceVM VM { get; set; }

        public SaveCommand(LaPalaceVM laPalaceVM)=> VM = laPalaceVM;

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

        public bool CanExecute(object parameter)
        {
            if (parameter is bool) return (bool)parameter;
            return false;
        }

        public void Execute(object parameter)
        {
            VM.SaveFunction();
        }
    }
}
