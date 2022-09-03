using Microsoft.EntityFrameworkCore;
using TutorMe.Data;
using TutorMe.Models;

namespace TutorMe.Services
{
    public interface IModuleService
    {
        IEnumerable<Module> GetAllModules();
        Module GetModuleById(Guid id);
        Guid createModule(Module module);
        bool deleteModuleById(Guid id);
    }
    public class ModuleServices : IModuleService
    {

        private TutorMeContext _context;
        public ModuleServices(TutorMeContext context)
        {
            _context = context;
        }

        public IEnumerable<Module> GetAllModules()
        {
            return _context.Module;
        }

        public Module GetModuleById(Guid id)
        {
            var module = _context.Module.Find(id);
            if (module == null)
            {
                throw new KeyNotFoundException("Module not found");
            }
            return module;
        }
        public Guid createModule(Module module)
        {
            if (_context.Module.Where(e => e.ModuleName == module.ModuleName && e.InstitutionId == module.InstitutionId).Any())
            {
                throw new KeyNotFoundException("This Module already exists, Please log in");
            }
            module.ModuleId = Guid.NewGuid();
            _context.Module.Add(module);
            _context.SaveChanges();
            return module.ModuleId;
        }

        public bool deleteModuleById(Guid id)
        {
            var module = _context.Module.Find(id);
            if (module == null)
            {
                throw new KeyNotFoundException("Module not found");
            }
            _context.Module.Remove(module);
            _context.SaveChanges();
            return true;
        }
    }
}