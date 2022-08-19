#nullable disable

namespace Api.Models
{
    public partial class Group
    {
        public Guid Id { get; set; }
        public string ModuleCode { get; set; }
        public string ModuleName { get; set; }
        public string Tutees { get; set; }
        public string TutorId { get; set; }
        public string Description { get; set; }

    }
}
