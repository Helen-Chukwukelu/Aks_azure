using System.ComponentModel.DataAnnotations;

using Fmi.Configuration.Validation;

namespace ReferenceData.Configuration
{
    public class ReferenceDataConfiguration : ConfigurationValidator
    {
        [Required]
        public ConnectionStrings ConnectionStrings { get; set; }
    }
}
