using System;
using System.Drawing;
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
            if (parameter is Bitmap)
            {
                return parameter == null ? false : true;
            }
            else return false;
        }

        public void Execute(object parameter)
        {
            SaveFunction();
        }

        private void SaveFunction()
        {
            throw new NotImplementedException();
        }
    }
}
