using System;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Tutors.Data;
using Tutors.Services;

namespace Tutors.Repo{
    
    public class TutorRepo : ITutor{
       
        private readonly TutorDbContext db;
        public TutorRepo(TutorDbContext database) {
            db = database;
        }
        public IQueryable<Tutor> GetTutors =>db.Tutors;
        public async Task<ModelReturned> DeleteAsync(int? id)
        {
            ModelReturned model = new ModelReturned();
            Tutor tutor = await GetTutor(id);
            if (tutor != null) {
                try {
                    db.Tutors.Remove(tutor);
                    await db.SaveChangesAsync();
                    model.Flag = true;
                    model.Message = "Tutor has been deleted";

                }
                catch (Exception ex) {
                    model.Flag = false;
                    model.Message = ex.Message;
                }
            }
            else {
                model.Flag = false;
                model.Message = "Tutor is not found";
            }
            return model;
        }

        public async Task<Tutor> GetTutor(int? id){
            //Tutor tutor = db.Tutors.Find(id);
            //return tutor;
            Tutor tutor = new Tutor();
            if (id != null) {
                tutor = await db.Tutors.FindAsync(id);
            }
            return tutor;
        }

        public async Task<ModelReturned> Save(Tutor _tutor) {
            ModelReturned model = new ModelReturned();
            //Add if  StudentId=0
            if (_tutor.Id == 0) {
                try {
                    await db.AddAsync(_tutor);
                    await db.SaveChangesAsync();

                    model.Id = _tutor.Id;
                    model.Flag = true;
                    model.Message = "Has Been Added.";

                }
                catch (Exception ex) {
                    model.Flag = false;
                    model.Message = ex.ToString();
                }
            }
            else if (_tutor.Id != 0) {
                Tutor tut = await GetTutor(_tutor.Id);
                tut.Id = _tutor.Id;
                tut.FirstName = _tutor.FirstName;
                tut.Surname = _tutor.Surname;
                tut.IdNumber = _tutor.IdNumber;
                tut.Modules = _tutor.Modules;
                tut.Email = _tutor.Email;
                tut.Tutees = _tutor.Tutees;

                try {
                    await db.SaveChangesAsync();
                    model.Id = _tutor.Id;
                    model.Flag = true;
                    model.Message = "The Tutor has been updated";
                }
                catch (Exception ex) {
                    model.Flag = false;
                    model.Message = ex.ToString();
                }
            }

            return model;

        }
    }
}
