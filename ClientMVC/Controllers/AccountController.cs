using ClientMVC.ViewModels;
using RealPoc.Api.Datastore.SqlDb;
using RealPoc.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using RealPoc.Api.Abstractions;
using Microsoft.AspNet.Identity;
using Microsoft.Owin.Security;
using System.Security.Claims;
using System.Web.Helpers;

namespace ClientMVC.Controllers
{
    public class AccountController : BaseController
    {
        public AccountController(IGeneralRepository GeneralRepository) : base(GeneralRepository)
        {
        }



        // GET: /Account/Register
        [AllowAnonymous]
        public ActionResult Register()
        {
            return View();
        }

        // POST: /Account/Register
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Register(RegisterViewModel model)
        {
            if (ModelState.IsValid)
            {
                var hashedPassword = Crypto.HashPassword(model.Password);
                var user = new User { Email = model.Email, Password= hashedPassword};

                try
                {
                   
                    var result = await _GeneralRepository.RegisterUser(user);

                    if (result != null)
                    {
                        IdentitySignin(result, false);
                        return RedirectToAction("Index", "Home");
                    }
                }
                catch(Exception e)
                {

                    ModelState.AddModelError("sqlError", "Something went wrong ! User with this Email already exists! Error Info:"+ e.Message);
                    return View(model);
                }

              
             
            }

            // If we got this far, something failed, redisplay form
            return View(model);
        }


        // GET: /Account/Login
        [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        // POST: /Account/Login
        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Login(LoginViewModel model, string returnUrl)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }


            var user = new User { Email = model.Email};
            var result = await _GeneralRepository.LoginUser(user);

            if (result == null)
            {

                ModelState.AddModelError("loginError", "Wrong Username or Password");
                return View(model);

            }
            else if (ValidateCredentials(result.Password, model.Password))
            {

                IdentitySignin(result, model.RememberMe);
                return RedirectToLocal(returnUrl);
            }


            ModelState.AddModelError("loginError", "Wrong Username or Password");
            return View(model);
        }


        public bool ValidateCredentials(string PasswordFromDatabase, string password)
        {
            var hashedPassword = PasswordFromDatabase;
            var doesPasswordMatch = Crypto.VerifyHashedPassword(hashedPassword, password);
            return doesPasswordMatch;
        }

        // POST: /Account/LogOff
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult LogOff()
        {
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return RedirectToAction("Index", "Home");
        }


        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }

            return RedirectToAction("Index", "Home");
        }


        public void IdentitySignin(User user, bool isPersistent = false)
        {
          

            var claims = new List<Claim>();

            // create *required* claims
            claims.Add(new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()));
            claims.Add(new Claim(ClaimTypes.Email, user.Email));
            claims.Add(new Claim(ClaimTypes.Name, user.Email));

            var identity = new ClaimsIdentity(claims, DefaultAuthenticationTypes.ApplicationCookie);

            // add to user here!
            AuthenticationManager.SignIn(new AuthenticationProperties()
            {
                AllowRefresh = true,
                IsPersistent = isPersistent,
                ExpiresUtc = DateTime.UtcNow.AddDays(7)
            }, identity);
        }

        public void IdentitySignout()
        {
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie,
                                          DefaultAuthenticationTypes.ExternalCookie);
        }

        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }


    }
}